class ErlangLs < Formula
  desc "Erlang Language Server"
  homepage "https://erlang-ls.github.io/"
  url "https://github.com/erlang-ls/erlang_ls/archive/refs/tags/0.51.0.tar.gz"
  sha256 "1eb8748755b2990d02e8ba8387f6f9ef04c398ad2975fa606387f3b9bdbafd1c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2fe166328193ee1566c5fda0f839aa716889eb98b11e71f04623fc4182b6d4fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1f16fa8f981d2e7e527c955cc11c427f100e828567d22b0f81006c0d617a2b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f416fc6cd0c31c38e56fed9a4aea418ac41f2c186e2973b214ef0508176db31"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea70c28ef7916cfc16420d0ec39fa833d6cb1cf5d86bd9724f11fb6aed0dd03c"
    sha256 cellar: :any_skip_relocation, ventura:        "c14d2edebf016e7568cb662622e5d1759209e39d33b2a3431be938c037d2b435"
    sha256 cellar: :any_skip_relocation, monterey:       "a1f0bf9de64ffeccb0b5b4a076c646b8eb097565f8e6936fc74d7c7ad7c0b9ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0a01d50fce81eb0230f5ffff9c87b2b6340644e0ffe1aea768537e230000f6d"
  end

  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    output = pipe_output("#{bin}/erlang_ls", nil, 1)
    assert_match "Content-Length", output
  end
end
