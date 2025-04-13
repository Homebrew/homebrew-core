class Has < Formula
  desc "Checks presence of various command-line tools and their versions on the path"
  homepage "https://github.com/kdabir/has"
  url "https://github.com/kdabir/has/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "d45be15f234556cdbaffa46edae417b214858a4bd427a44a2a94aaa893da7d99"
  license "MIT"
  head "https://github.com/kdabir/has.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "dd0eec9c703fb35356c4931881f3c5106a4fdee227e39c2c2844fecf025509e8"
  end

  def install
    bin.install "has"
  end

  test do
    assert_match "git", shell_output("#{bin}/has git")
    assert_match version.to_s, shell_output("#{bin}/has --version")
  end
end
