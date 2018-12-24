class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      :tag      => "v1.4.4",
      :revision => "6096d231196bafdfba3a8ac325455b057c5898a4"
  head "https://github.com/mas-cli/mas.git"

  bottle do
    cellar :any
    sha256 "24e1ba2d2675d1f939bbfc6ab979fbc923560ed1dbf419034e43224b38c6584b" => :mojave
    sha256 "6c7cab37e3b21330a8fed37b571dcb31d020588739ef6e256039b54fcf7abdc0" => :high_sierra
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
