class Gdrive < Formula
  desc "Google Drive CLI Client"
  homepage "https://github.com/gdrive-org/gdrive"
  url "https://github.com/gdrive-org/gdrive/archive/2.1.1.tar.gz"
  sha256 "9092cb356acf58f2938954784605911e146497a18681199d0c0edc65b833a672"
  license "MIT"
  head "https://github.com/gdrive-org/gdrive.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c352c82a925ec14ef3e88e2483bdb7147de246226fb35fe6830e9f28eb6f6805"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f991723008683908cb3a37497348e9813314807b9000e90de1e2130f2342554d"
    sha256 cellar: :any_skip_relocation, monterey:       "861b550af0728ddbf48274164bd7207d73349d7800dad8a4c0760ea2fecc9b9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d96fff9fcee61b32a8185cae41d1f5b21f36dd22f235852f283b46fcd3b066e"
    sha256 cellar: :any_skip_relocation, catalina:       "08947085778a3414d976c4dbda157b58704c60700621348f621d74a589c68149"
    sha256 cellar: :any_skip_relocation, mojave:         "a1f4a672700f4348173b184e04aa6da8196ad93d44efbd5122aa304c88d0cce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d687e4d537911f156c2f5cfd0a88fe8c44793eef89c497849e2130ab138d70e"
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
