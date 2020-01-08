class Abduco < Formula
  desc "Provides session management: i.e. separate programs from terminals"
  homepage "http://www.brain-dump.org/projects/abduco"
  url "http://www.brain-dump.org/projects/abduco/abduco-0.6.tar.gz"
  sha256 "c90909e13fa95770b5afc3b59f311b3d3d2fdfae23f9569fa4f96a3e192a35f4"
  head "https://github.com/martanne/abduco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d78f6c36e0933f3c55bc96d4ca5c0e4e24030598702423ed752130721e7b8dc" => :catalina
    sha256 "b3c5d87a9da3f70e3fd16fdf7a3d2327b41c96ab74d62e2a6efa2e3733ec78f3" => :mojave
    sha256 "8ca092b6fd5a6ad39e3c91186421bca2943af6bfdbae4ea95254b36d1e109a78" => :high_sierra
    sha256 "9367a86666aad4d14cecf2d7c20f897d3eb92d5cd913af43081d80b9452e19fd" => :sierra
    sha256 "62b4673f4fba1d3c5b201b972e220a2736ec053e0c83b1369bb4e5641a71f8e4" => :el_capitan
    sha256 "17338a1f1f2cace2bfb40c79d746ad60c6604555e8fb34476ec4ef9a2f68234e" => :yosemite
    sha256 "1f48e0d684ba7b41768b5aa770df9c8ee716a3132d3c8043b4f7ff970c925ac5" => :mavericks
  end

  def install
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    result = shell_output("#{bin}/abduco -v")
    result.force_encoding("UTF-8") if result.respond_to?(:force_encoding)
    assert_match /^abduco-#{version}/, result
  end
end
