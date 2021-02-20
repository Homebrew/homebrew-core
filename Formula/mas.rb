class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v1.8.0",
      revision: "9eaf57a5de836ce5e5435a8df14da4aa1b7d7444"
  license "MIT"
  head "https://github.com/mas-cli/mas.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ef2ed904d1283722af006811471484cb1c9c73b255a766b5c0c65ecd1654c8d8"
    sha256 cellar: :any, big_sur:       "dc98d69cfa94467e046b443c088a6097fe0ce0d2935e37046815fa3a984a0ca4"
    sha256 cellar: :any, catalina:      "2e7ffedf674543f98c2b95868b6a23db208cb2e6a3ec1ddbb3553ddab0cf9a68"
  end

  depends_on "carthage" => :build
  depends_on :macos
  if Hardware::CPU.arm?
    depends_on xcode: ["12.2", :build]
  else
    depends_on xcode: ["11.4", :build]
  end

  def install
    # Working around build issues in dependencies
    # - Prevent warnings from causing build failures
    # - Prevent linker errors by telling all lib builds to use max size install names
    xcconfig = buildpath/"Overrides.xcconfig"
    xcconfig.write <<~EOS
      GCC_TREAT_WARNINGS_AS_ERRORS = NO
      OTHER_LDFLAGS = -headerpad_max_install_names
    EOS
    ENV["XCODE_XCCONFIG_FILE"] = xcconfig

    # Only build necessary dependencies
    system "carthage", "bootstrap", "--platform", "macOS", "Commandant"
    system "script/install", prefix

    bash_completion.install "contrib/completion/mas-completion.bash" => "mas"
    fish_completion.install "contrib/completion/mas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
    assert_include shell_output("#{bin}/mas info 497799835"), "Xcode"
  end
end
