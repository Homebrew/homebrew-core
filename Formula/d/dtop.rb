class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://github.com/amir20/dtop/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "504eb5f81e04cfb40b80cf1893c73e0c3f3bffa85e28d459ee158166b9e12731"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eaa06d9f62d9621b56ff3ba117278c4d8edcf9dcb1e9d9cac67d2ae3863e7c3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3528fac4df1b3e3d0c3aaa4bd275c95ff4823c9df61af366c860bba33c4a2e1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d20acd66148638916bd8535263203b0edbbd5b6a57b55bcc96bdbc684bda37dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e54c462ad770530697605907026a39af9d8a952741a222c353b1520fffdc0c9a"
    sha256 cellar: :any,                 arm64_linux:   "8771859b084360f1c68c089db3ae42b69c59007b4d77946c76b56184cadd90a4"
    sha256 cellar: :any,                 x86_64_linux:  "39559e92a926625ca848e80532c4f589631597134d7dfb4b595096e140a781dd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end
