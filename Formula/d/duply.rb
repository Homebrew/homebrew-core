class Duply < Formula
  desc "Frontend to the duplicity backup system"
  # Canonical domain: duply.net
  # Historical homepage: https://web.archive.org/web/20131126005707/ftplicity.sourceforge.net
  homepage "https://sourceforge.net/projects/ftplicity/"
  url "https://downloads.sourceforge.net/project/ftplicity/duply%20%28simple%20duplicity%29/2.5.x/duply_2.5.3.tgz"
  sha256 "636c1725f9832637ad27bc53f9069134311bab9308a59281665036accf1a9eda"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/duply[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5c249fda1aac473ba63b532dcc63add0deefeb5dc5cb704c58dd703f4334ee80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ed03ab07e478344d6e19dffc805f3d8c37bf5b4f3f2e0b9f38355a60a8841a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ed03ab07e478344d6e19dffc805f3d8c37bf5b4f3f2e0b9f38355a60a8841a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80d56bc4cf519e9a39b1147b323885d5cd90eb18125ac5e6d976b67eb0993693"
    sha256 cellar: :any_skip_relocation, sonoma:         "004f9eadc103bac53d9edb45ba5fdb1292ff7b5cae3967c45bb0a12b086a70d0"
    sha256 cellar: :any_skip_relocation, ventura:        "004f9eadc103bac53d9edb45ba5fdb1292ff7b5cae3967c45bb0a12b086a70d0"
    sha256 cellar: :any_skip_relocation, monterey:       "adef8a1522da5bd1cff761da82c44ed9ec7f5f73e5a588495171ca319b2771c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18a0180f279a28f47cdf31f0d98556fa29851fcad84313848270090277afb5df"
  end

  depends_on "duplicity"

  def install
    bin.install "duply"
  end

  test do
    system bin/"duply", "-v"
  end
end
