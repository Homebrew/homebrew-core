class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v1.7.1",
      revision: "b8dcb4ce4b1d78ada7556565dd5c73e9913758d8"
  license "MIT"
  head "https://github.com/mas-cli/mas.git"

  bottle do
    cellar :any
    sha256 "432091a534d0a1f753fcf953fb1c20c10ef5762b7f8922cb378c3dcd36898d30" => :big_sur
    sha256 "e6de2f98ebd21885a9827664fe1b7eea5516a7fd75d5b7383e3a9b088591a27f" => :catalina
    sha256 "8b6dc4e261ebdc8e2f93afe87da3db4d482eb3d8a0358ab19a0485d434550e77" => :mojave
  end

  depends_on "carthage" => :build
  depends_on xcode: ["10.2", :build]

  def install
    # Working around build issues in dependencies
    # - Prevent warnings from causing build failures
    # - Prevent linker errors by telling all lib builds to use max size install names
    # - Ensure dependencies build for the current CPU; otherwise Commandant will
    #   build for x86_64 when running arm64
    xcconfig = buildpath/"Overrides.xcconfig"
    xcconfig.write <<~EOS
      GCC_TREAT_WARNINGS_AS_ERRORS = NO
      OTHER_LDFLAGS = -headerpad_max_install_names
      VALID_ARCHS = #{Hardware::CPU.arch}
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
