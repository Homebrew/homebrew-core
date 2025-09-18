class GdriveAT2 < Formula
  desc "Google Drive CLI Client"
  homepage "https://github.com/prasmussen/gdrive"
  url "https://github.com/prasmussen/gdrive/archive/refs/tags/2.1.1.tar.gz"
  sha256 "9092cb356acf58f2938954784605911e146497a18681199d0c0edc65b833a672"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0de9006717faf05041e145b7412c2b088aa858df265e08bccd4de81234984819"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ad935c13ec41e8b5876ee821995bd6a853b67b38e17626b9a636c9e8680db60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4135e1686fca80cb9e6e4366af6e99d5631b896854500bae74907dd57b87d23f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c0222446c65a22470b13d3ae825599d125af37afe9fdfc1f73e3c4b99fa657d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad269a367d382c2d9e78b9cd75978e1f1efef79317f0f6cfa1b444d2f1e16afc"
    sha256 cellar: :any_skip_relocation, ventura:        "7b7d7cf1547348e22b8998fb3cf588667904eafd628dc97afbcef047f01ace83"
    sha256 cellar: :any_skip_relocation, monterey:       "1529979b500ba4dd3a9fe931a4f6cff46bb2e3bee83526da960b7459ebf5ecca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1ea79701fc05370bff771480e1839c0ded5d9cdd9cc9c647207fae1ebafda32"
  end

  keg_only :versioned_formula

  disable! date: "2024-11-20", because: :repo_archived

  depends_on "go" => :build

  patch do
    url "https://github.com/prasmussen/gdrive/commit/faa6fc3dc104236900caa75eb22e9ed2e5ecad42.patch?full_index=1"
    sha256 "ee7ebe604698aaeeb677c60d973d5bd6c3aca0a5fb86f6f925c375a90fea6b95"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"gdrive"), "-mod=readonly"
    doc.install "README.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gdrive version")
  end
end
