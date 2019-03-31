class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      :tag      => "v1.6.3",
      :revision => "3ac7e51b9e9fdd33f7caf7c77bebf09bf0cce44b"
  head "https://github.com/mas-cli/mas.git"

  bottle do
    cellar :any
    sha256 "f9909b8950efa64b86585fecc460ca280ebde507e864ba3d3f5b9e743b275a88" => :mojave
    sha256 "9763488be11655b5b0868eff3f3f4cd91031f0da80f74bf38f292f62798cd98b" => :high_sierra
  end

  depends_on "carthage" => :build
  depends_on :xcode => ["10.1", :build]

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

    # Only build necessary dependencies (Commandant, Result)
    system "carthage", "bootstrap", "--platform", "macOS", "Commandant", "Result"
    system "script/install", prefix

    bash_completion.install "contrib/completion/mas-completion.bash" => "mas"
    fish_completion.install "contrib/completion/mas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
    assert_include shell_output("#{bin}/mas info 497799835"), "Xcode"
  end
end
