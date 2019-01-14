class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      :tag      => "v1.6.0",
      :revision => "af1e9d4cb404164fbe4e8db73159e1e15c0b3184"
  head "https://github.com/mas-cli/mas.git"

  bottle do
    cellar :any
    sha256 "c66233398bd402e91714a74678261b97fd22f2d5cee20bd62a350c2183efcba8" => :mojave
    sha256 "a9bf625303328572bf0d28c7f6e940a7aa7ad559ea6b1b5fc9fc3a3a0619409f" => :high_sierra
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
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
    assert_include shell_output("#{bin}/mas info 497799835"), "Xcode"
  end
end
