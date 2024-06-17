class NetsurfBuildsystem < Formula
  desc "Makefiles shared by NetSurf projects"
  homepage "https://source.netsurf-browser.org/buildsystem.git"
  url "https://download.netsurf-browser.org/libs/releases/buildsystem-1.10.tar.gz"
  sha256 "3d3e39d569e44677c4b179129bde614c65798e2b3e6253160239d1fd6eae4d79"
  license "MIT"
  head "https://git.netsurf-browser.org/buildsystem.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "940a502f39ef0cda291801f35221b65d3d21aeee215322ad935d2b829b687e6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "940a502f39ef0cda291801f35221b65d3d21aeee215322ad935d2b829b687e6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "940a502f39ef0cda291801f35221b65d3d21aeee215322ad935d2b829b687e6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7594be02107747afd03a214ad6baeb160ef751b62727ff94c8379cb9c7154277"
    sha256 cellar: :any_skip_relocation, ventura:        "7594be02107747afd03a214ad6baeb160ef751b62727ff94c8379cb9c7154277"
    sha256 cellar: :any_skip_relocation, monterey:       "7594be02107747afd03a214ad6baeb160ef751b62727ff94c8379cb9c7154277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "940a502f39ef0cda291801f35221b65d3d21aeee215322ad935d2b829b687e6d"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"src").mkpath

    (testpath/"Makefile").write <<~EOS
      COMPONENT := hello
      COMPONENT_VERSION := 0.1.0
      COMPONENT_TYPE ?= binary
      include $(NSSHARED)/makefiles/Makefile.tools
      include $(NSBUILD)/Makefile.top
      INSTALL_ITEMS := $(INSTALL_ITEMS) /bin:$(BUILDDIR)/$(COMPONENT)
    EOS

    (testpath/"src/Makefile").write <<~EOS
      DIR_SOURCES := main.c
      include $(NSBUILD)/Makefile.subdir
    EOS

    (testpath/"src/main.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("Hello, world!");
        return 0;
      }
    EOS

    args = %W[
      NSSHARED=#{pkgshare}
      PREFIX=#{testpath}
    ]

    system "make", "install", *args
    assert_equal "Hello, world!", shell_output(testpath/"bin/hello")
  end
end
