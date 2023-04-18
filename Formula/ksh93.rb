class Ksh93 < Formula
  desc "KornShell, ksh93"
  homepage "https://github.com/ksh93/ksh#readme"
  url "https://github.com/ksh93/ksh/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "7ab7785a277f96acd8b645dc70769adf0cc92546dac356639852bff1d708275f"
  license "EPL-2.0"
  head "https://github.com/ksh93/ksh.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e3c9d85dc84136fb32e1b922359a39c4a53ae9515bd056316e15657c7b4510c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e7454d428bfbd6d0179e4fa9ba47bfb2431de6ef06e65396359072da90fdd6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8749b975877f34b340a823d1b66fa2a0b31f27674ddd7f05dfff28d655e56cf"
    sha256 cellar: :any_skip_relocation, ventura:        "eeed5bbbe9300e033fcbd351fcc58c051419529ec00c3dabfa794cf59bcaa46f"
    sha256 cellar: :any_skip_relocation, monterey:       "559d57f600a47a3ac16b21aca6801e7c53830742145c751add0786616d8e0a17"
    sha256 cellar: :any_skip_relocation, big_sur:        "fee9f1e32efa911bae78e25abdcc43c708908a68b7388bf1fc2b2a3bac45d189"
    sha256 cellar: :any_skip_relocation, catalina:       "0b8ea5bee41bbd6813d9d8f8782867b0e890d650e976d5afe829764f149fdd3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f48e51ee03cc6d1956d6df4e062869e8820e163c8fc9a78a9688603c4de6f7a3"
  end

  def install
    system "bin/package", "verbose", "make"
    system "bin/package", "verbose", "install", prefix
    %w[ksh93 rksh rksh93].each do |alt|
      bin.install_symlink "ksh" => alt
      man1.install_symlink "ksh.1" => "#{alt}.1"
    end
    doc.install "ANNOUNCE"
    doc.install %w[COMPATIBILITY README RELEASE TYPES].map { |f| "src/cmd/ksh93/#{f}" }
  end

  test do
    system "#{bin}/ksh93 -c 'A=$(((1./3)+(2./3)));test $A -eq 1'"
  end
end
