class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git",
      :tag      => "0.33.0",
      :revision => "c8ac06e106b6b61f907918bfb2b7a5c432de4678",
      :shallow  => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  bottle do
    cellar :any
    sha256 "265d7c1e06f0acb8f5615b6c1d71ffc05b05844bb0fb1da931799ec18ca318a5" => :mojave
    sha256 "576468454342dc278837901358ce2f325584307cafd457ae9ada46436b84a941" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]

  def install
    if MacOS::Xcode.version >= "10.2" && (0..3).any? { |x| String(MacOS.full_version) == "10.14.#{x}" }
      odie [
        "If a user on sub-10.14.4-Mojave using a Swift 5 CLI app happens to remove or relocate " \
        "`Xcode.app`, say to make room for `Xcode-beta.app`, without the additional package " \
        "installed to `/usr/lib/swift`, an app like this will no longer run.",
        "See <https://github.com/Homebrew/brew/pull/5940#issuecomment-477583315>.",
        "Perhaps, try `--force-bottle` with `DEVELOPER_DIR='/var/empty' HOMEBREW_NO_BOTTLE_SOURCE_FALLBACK=true brew`?",
        "Or, perhaps, if Xcode 10.1 is available, `xcode-select` that?",
      ].join("\n• ")
    end

    system "make", "prefix_install", "PREFIX=#{prefix}"
    bash_completion.install "Source/Scripts/carthage-bash-completion" => "carthage"
    zsh_completion.install "Source/Scripts/carthage-zsh-completion" => "_carthage"
    fish_completion.install "Source/Scripts/carthage-fish-completion" => "carthage.fish"
  end

  test do
    (testpath/"Cartfile").write 'github "jspahrsummers/xcconfigs"'
    system bin/"carthage", "update"
  end
end
