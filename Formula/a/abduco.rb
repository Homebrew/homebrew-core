class Abduco < Formula
  desc "Provides session management: i.e. separate programs from terminals"
  homepage "https://www.brain-dump.org/projects/abduco/"
  url "https://github.com/martanne/abduco/releases/download/v0.6/abduco-0.6.tar.gz"
  sha256 "c90909e13fa95770b5afc3b59f311b3d3d2fdfae23f9569fa4f96a3e192a35f4"
  license "ISC"
  head "https://github.com/martanne/abduco.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c2c4bcd34f6b83f1a2b3a04e223b7eab8b29d6a39043127f422f59d7c38c7e6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "216c0c4a4ac3e537b0846cb998b36ea986de0d42fb3b2c50b0dfdd4da38a7418"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6db16f93fb69cad1e8ef83fcbe67783e9dce80f5cf2e36caa56b85d81cf3938b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b07ab80b2d588ae9ed65d615b8e4f12bf04b8e86eec0ffd407a4955aef9a2dba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3e01e687a45b2458311702b5b48b8d3bb8d681388cacc85e7fb26d0be6b7720"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e261303a69440aa46e09bfc3be3b7fb0c5cb6b2a3f6fbeb94338491a8538a90a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4fe0b940ecf7445830a525f829bc2f2b3bf358947117ca93642336a21ff2090"
    sha256 cellar: :any_skip_relocation, ventura:        "cec640c52bce7b9d63223b949ad4e30a96cb1acc58c8f95ab5017104cd41aac6"
    sha256 cellar: :any_skip_relocation, monterey:       "8c9d9c494114dfcb8c231d5823afa980bd0b7a1d055c30ea7b60a9e4d7a92878"
    sha256 cellar: :any_skip_relocation, big_sur:        "a010ab98531eaafdb9d35a7f2ca6a0583b6566be603f95b721f41e1037eafacb"
    sha256 cellar: :any_skip_relocation, catalina:       "6d78f6c36e0933f3c55bc96d4ca5c0e4e24030598702423ed752130721e7b8dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4e84ed7e82b55ae643f46c6b81488e55535269cb37a95e7eec87a06b60f66427"
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
