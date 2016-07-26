class Eiffelstudio < Formula
  desc "Development environment for the Eiffel language"
  homepage "https://www.eiffel.com"
  url "https://ftp.eiffel.com/pub/download/16.05/eiffelstudio-16.05.tar"
  sha256 "7154ee73671b7b29892d7b6ac5ef3819dc2aec95c262e95e9482c6f35a897e25"

  bottle do
    cellar :any
    sha256 "4231e0735d8a2db64e084e84bc9fe9eab31fd6cdc144f6519f07e5db87812dc8" => :el_capitan
    sha256 "ee15c05e2f4410e479e338b7fb263fdccb03e55cf3dbceb3724140ea872cd058" => :yosemite
    sha256 "2eda67f3856bb63209d0ca8292d47feea8fd3077fbfc345e7fc5bd03599d833e" => :mavericks
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
    prefix.install Dir["Eiffel_16.05/*"]
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
