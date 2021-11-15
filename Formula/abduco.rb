class Abduco < Formula
  desc "Provides session management: i.e. separate programs from terminals"
  homepage "https://www.brain-dump.org/projects/abduco"
  url "https://github.com/martanne/abduco/releases/download/v0.6/abduco-0.6.tar.gz"
  sha256 "c90909e13fa95770b5afc3b59f311b3d3d2fdfae23f9569fa4f96a3e192a35f4"
  license "ISC"
  head "https://github.com/martanne/abduco.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3e01e687a45b2458311702b5b48b8d3bb8d681388cacc85e7fb26d0be6b7720"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e261303a69440aa46e09bfc3be3b7fb0c5cb6b2a3f6fbeb94338491a8538a90a"
    sha256 cellar: :any_skip_relocation, monterey:       "8c9d9c494114dfcb8c231d5823afa980bd0b7a1d055c30ea7b60a9e4d7a92878"
    sha256 cellar: :any_skip_relocation, big_sur:        "a010ab98531eaafdb9d35a7f2ca6a0583b6566be603f95b721f41e1037eafacb"
    sha256 cellar: :any_skip_relocation, catalina:       "6d78f6c36e0933f3c55bc96d4ca5c0e4e24030598702423ed752130721e7b8dc"
    sha256 cellar: :any_skip_relocation, mojave:         "b3c5d87a9da3f70e3fd16fdf7a3d2327b41c96ab74d62e2a6efa2e3733ec78f3"
    sha256 cellar: :any_skip_relocation, high_sierra:    "8ca092b6fd5a6ad39e3c91186421bca2943af6bfdbae4ea95254b36d1e109a78"
    sha256 cellar: :any_skip_relocation, sierra:         "9367a86666aad4d14cecf2d7c20f897d3eb92d5cd913af43081d80b9452e19fd"
    sha256 cellar: :any_skip_relocation, el_capitan:     "62b4673f4fba1d3c5b201b972e220a2736ec053e0c83b1369bb4e5641a71f8e4"
    sha256 cellar: :any_skip_relocation, yosemite:       "17338a1f1f2cace2bfb40c79d746ad60c6604555e8fb34476ec4ef9a2f68234e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2129c6039968a818f71997e800575b581128b56f8783eeb32c990f8a5e8b81ad"
  end

  def install
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    result = shell_output("#{bin}/abduco -v")
    result.force_encoding("UTF-8") if result.respond_to?(:force_encoding)
    assert_match(/^abduco-#{version}/, result)
  end
end
