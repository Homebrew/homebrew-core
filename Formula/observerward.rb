class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.8.11.tar.gz"
  sha256 "17a9ee8e4a29debaa92b7af1c2f8e72149a01e9673c493128e922fd47a49a8e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e20c2e11c890f6fa12d04a564f247066faf36597a2afdc5db5ab891a0c911f6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0d4846506b7a5cde47ca78865feb0c88d7e6c71428da54c1ed59c24de925d46"
    sha256 cellar: :any_skip_relocation, monterey:       "20bd7b2501b2c399212e7e4fb1dd54996d50f91b541010df7072e4c013b0b8a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fff52b456ea4468823dde85a0139a69fc3b8af982a56cf464ae3f8346cff179"
    sha256 cellar: :any_skip_relocation, catalina:       "1c18a91c40c907a91643df1ec0b0efc681367804b8c094656b5f139bf4e4a355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d967ad2efdcf3de4551a507227381bc87ef3e65831374cc64f6f379c166577c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "swagger", shell_output("#{bin}/observer_ward -t https://httpbin.org")
  end
end
