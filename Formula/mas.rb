class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      :tag      => "v1.6.3",
      :revision => "3ac7e51b9e9fdd33f7caf7c77bebf09bf0cce44b"
  head "https://github.com/mas-cli/mas.git"

  bottle do
    cellar :any
    sha256 "2069b8c1c1a64c2fb91cc1c25ab9c9890c61f2182224b9e0605a35a151bb85bd" => :catalina
    sha256 "3dd5a50b551a37c164c31375cc8498ba870e29e50086bd5c4c294bc26708a6d2" => :mojave
    sha256 "a0d1e45203448c08420c3eab2d40ef957fd22c8e40fbeb067bc7bffe4f08dfe2" => :high_sierra
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
