class ModelicaStandardLibrary < Formula
  desc "Free library from the Modelica Association"
  homepage "https://modelica-doc.lovable.app"
  url "https://github.com/modelica/ModelicaStandardLibrary/releases/download/v4.1.0/ModelicaStandardLibrary_v4.1.0.zip"
  sha256 "5409cfa17797c52d866dc9d2675badc1378b4bbf88066e60899a489cb1cb8a2d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    pkgshare.install "Modelica #{version}" => "Modelica"
  end

  test do
    assert_path_exists pkgshare/"Modelica/package.mo"
  end
end
