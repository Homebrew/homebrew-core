class Curaengine < Formula
  desc "C++ 3D printing GCode generator"
  homepage "https://github.com/Ultimaker/CuraEngine"
  url "https://github.com/Ultimaker/CuraEngine/archive/refs/tags/4.13.1.tar.gz"
  sha256 "283f62326c6072cdcef9d9b84cb8141a6072747f08e1cae6534d08ad85b1c657"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https://github.com/Ultimaker/CuraEngine.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cdfaed191caccb6b4711b496908dc49943a867d3cf9ed73f05cf8691d41243a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df46dbfdd389c20a311ffe46ccd8807496c60fdbb27ae3ed07f10592b0b8c27d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87834e91270428e01cf4c8dfac8ee269f98c2ec52b4fb4a2759e6a7ad3dc9adf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f9480ae014cdd9519ceeca9b0ee676b5a0152f6e888fe3d3ab415e83eae71d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "8969820813eb9cabfc6cc2e72a1d81615601ca3f6db913daab6e45570981519a"
    sha256 cellar: :any_skip_relocation, ventura:        "77ea9ab7d45a4e0b896b556fc2223838902a894d70fdb7c0a7caa500c7538d10"
    sha256 cellar: :any_skip_relocation, monterey:       "bc652202bfd114cc016c7423301bd5c7dc7d309813d0d1b98c1bf970ebcd6cec"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbb7b34444997d50d12d7048209375da2c7070bac81aefe237fd74292ddc7c68"
    sha256 cellar: :any_skip_relocation, catalina:       "47934876717e2bdc11b9ede033c2fbb33c3a2a9a506066143dacf59f7c572ecd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b11d878824a2ddb8a966ee2134df5f48c45fb84de9894ca24fd5428bc8c7357a"
  end

  # Requires extensive patching to build & has minimal installs
  disable! date: "2024-01-12", because: :does_not_build

  depends_on "cmake" => :build

  fails_with gcc: "5"

  # The version tag in these resources (e.g., `/1.2.3/`) should be changed as
  # part of updating this formula to a new version.
  resource "fdmextruder_defaults" do
    url "https://raw.githubusercontent.com/Ultimaker/Cura/4.13.1/resources/definitions/fdmextruder.def.json"
    sha256 "c03847252f9dea37277a3151c0eaeec32ded5e4cd91eed62b58e420ad8cb7fef"
  end

  resource "fdmprinter_defaults" do
    url "https://raw.githubusercontent.com/Ultimaker/Cura/4.13.1/resources/definitions/fdmprinter.def.json"
    sha256 "6634679e3a9571f877e52e57a688d883dc4dc9fe6855a04c3b7be19b60f3a0b7"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DCMAKE_INSTALL_PREFIX=#{libexec}",
                            "-DENABLE_ARCUS=OFF"
      system "make", "install"
    end
    bin.install "build/CuraEngine"
  end

  test do
    testpath.install resource("fdmextruder_defaults")
    testpath.install resource("fdmprinter_defaults")
    (testpath/"t.stl").write <<~EOS
      solid t
        facet normal 0 -1 0
         outer loop
          vertex 0.83404 0 0.694596
          vertex 0.36904 0 1.5
          vertex 1.78814e-006 0 0.75
         endloop
        endfacet
      endsolid Star
    EOS

    system bin/"CuraEngine", "slice", "-j", "fdmprinter.def.json", "-l", "#{testpath}/t.stl"
  end
end
