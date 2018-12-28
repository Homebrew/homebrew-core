class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      :tag      => "v1.5.0",
      :revision => "ccaaa74c9593d04dc41fcff40af196fdad49f517"
  head "https://github.com/mas-cli/mas.git"

  bottle do
    cellar :any
    sha256 "24e1ba2d2675d1f939bbfc6ab979fbc923560ed1dbf419034e43224b38c6584b" => :mojave
    sha256 "6c7cab37e3b21330a8fed37b571dcb31d020588739ef6e256039b54fcf7abdc0" => :high_sierra
  end

  depends_on "carthage" => :build
  depends_on :xcode => ["10.1", :build]
  depends_on "trash"

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

    system "carthage", "bootstrap", "--platform", "macOS"
    system "script/install", prefix

    bash_completion.install "contrib/completion/mas-completion.bash" => "mas"
  end

  test do
    assert_include shell_output("#{bin}/mas info 497799835"), "By: Apple Inc."
  end
end
