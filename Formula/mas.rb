class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      :tag => "v1.4.3",
      :revision => "11a0e3e14e5a83aaaba193dfb6d18aa49a82b881"
  head "https://github.com/mas-cli/mas.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb05286adfb9ab0a63a8027391647fb874fa810c07d412505f5bc7911139a3f2" => :mojave
    sha256 "b7585ced3a93d60e95357e93d729913a6f628fda82359e77c6553c2e802c50dc" => :high_sierra
    sha256 "af5be6aa9902d9cfc2aa69dbf313441a7c201463d516face721f900ceae9556b" => :sierra
  end

  depends_on "carthage" => :build
  depends_on :xcode => ["10.0", :build]

  def install
    # Prevent warnings from causing build failures
    # Prevent linker errors by telling all lib builds to use max size install names
    xcconfig = buildpath/"Overrides.xcconfig"
    xcconfig.write <<~EOS
      GCC_TREAT_WARNINGS_AS_ERRORS = NO
      OTHER_LDFLAGS = -headerpad_max_install_names
    EOS
    ENV["XCODE_XCCONFIG_FILE"] = xcconfig

    system "carthage", "bootstrap", "--platform", "macOS"

    xcodebuild "install",
               "-project", "mas-cli.xcodeproj",
               "-scheme", "mas-cli Release",
               "-configuration", "Release",
               "OBJROOT=build",
               "SYMROOT=build"

    system "script/install", prefix

    bash_completion.install "contrib/completion/mas-completion.bash" => "mas"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
  end
end
