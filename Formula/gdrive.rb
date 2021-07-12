class Gdrive < Formula
  desc "Google Drive CLI Client"
  homepage "https://github.com/gdrive-org/gdrive"
  url "https://github.com/gdrive-org/gdrive/archive/2.1.1.tar.gz"
  sha256 "9092cb356acf58f2938954784605911e146497a18681199d0c0edc65b833a672"
  license "MIT"
  head "https://github.com/gdrive-org/gdrive.git"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4e4e3ac736173da5aaa2106ad3eb505cbb83e68f8a78b19a8b10c7bf2de50b3b"
    sha256 cellar: :any_skip_relocation, big_sur:       "0a22953fde6b318c5a658b639176d3bb445e8cd162cd1c28cebbb3984d652227"
    sha256 cellar: :any_skip_relocation, catalina:      "c89785f7d95e16fe113f649f47c80261ce7d335427d60c6543a3bd8d58eee522"
    sha256 cellar: :any_skip_relocation, mojave:        "e26ef4bec660913f42aa735c28f58393912d2d0293bf98a351fa2b27a1baee01"
    sha256 cellar: :any_skip_relocation, high_sierra:   "8fc5917762cd0b7622d35053931b41315606be97ba38ae34c9a67bf7ff87a1d3"
    sha256 cellar: :any_skip_relocation, sierra:        "b03e82ba9bb723b7f6225607b3127b9d515f0d79271f76b375b74324aecfb057"
  end

  depends_on "go" => :build

  patch do
    url "https://github.com/prasmussen/gdrive/commit/faa6fc3dc104236900caa75eb22e9ed2e5ecad42.patch?full_index=1"
    sha256 "ee7ebe604698aaeeb677c60d973d5bd6c3aca0a5fb86f6f925c375a90fea6b95"
  end

  def install
    system "go", "build", *std_go_args, "-mod=readonly"
    doc.install "README.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gdrive version")
  end
end
