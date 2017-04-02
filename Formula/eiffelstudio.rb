class Eiffelstudio < Formula
  desc "Development environment for the Eiffel language"
  homepage "https://www.eiffel.com"
  url "https://ftp.eiffel.com/pub/download/17.01/eiffelstudio-17.01.9.9700.tar"
  sha256 "610344e8e4bbb4b8ccedc22e57b6ffa6b8fd7b9ffee05edad15fc1aa2b1259a1"

  bottle do
    cellar :any
    sha256 "7946945393c414071a069c74adc5baeed9f93ab8be40d5f3bd6dbac77c7a8fd2" => :sierra
    sha256 "d6c4d4709cdde7bb552e8a72e3af85dfdff5fb25ac776d370cfd5da34e23dd9b" => :el_capitan
    sha256 "be7febcd611d5eb9282fa3480d00764cee7b4c91cf1dfd0cceb2d0618ba5a9f7" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def ise_platform
    if Hardware::CPU.ppc?
      "macosx-ppc"
    elsif MacOS.prefer_64_bit?
      "macosx-x86-64"
    else
      "macosx-x86"
    end
  end

  def install
    system "./compile_exes", ise_platform
    system "./make_images", ise_platform
    prefix.install Dir["Eiffel_17.01/*"]
    bin.mkpath
    env = { :ISE_EIFFEL => prefix, :ISE_PLATFORM => ise_platform }
    (bin/"ec").write_env_script(prefix/"studio/spec/#{ise_platform}/bin/ec", env)
    (bin/"ecb").write_env_script(prefix/"studio/spec/#{ise_platform}/bin/ecb", env)
    (bin/"estudio").write_env_script(prefix/"studio/spec/#{ise_platform}/bin/estudio", env)
    (bin/"finish_freezing").write_env_script(prefix/"studio/spec/#{ise_platform}/bin/finish_freezing", env)
    (bin/"compile_all").write_env_script(prefix/"tools/spec/#{ise_platform}/bin/compile_all", env)
    (bin/"iron").write_env_script(prefix/"tools/spec/#{ise_platform}/bin/iron", env)
    (bin/"syntax_updater").write_env_script(prefix/"tools/spec/#{ise_platform}/bin/syntax_updater", env)
    (bin/"vision2_demo").write_env_script(prefix/"vision2_demo/spec/#{ise_platform}/bin/vision2_demo", env)
  end

  test do
    # More extensive testing requires the full test suite
    # which is not part of this package.
    system prefix/"studio/spec/#{ise_platform}/bin/ec", "-version"
  end
end
