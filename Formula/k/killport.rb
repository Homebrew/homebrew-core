class Killport < Formula
  desc "Command-line tool to kill processes listening on a specific port"
  homepage "https://github.com/jkfran/killport"
  url "https://github.com/jkfran/killport/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "07bdc3d36b0cefd9c03c78a04fea46e5e9f487942c99cd70fcaf71676c45bf16"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "8df801d20f19d741790d393f1ee5632eb1a184378c144698a6177466b48fcf0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "885c694ffb6da77a98deccc68e4eb85a289a8aa11126270599991e53c20ad431"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b468626ea9766cd30304bc5e526e2f1068a96ca5d261d27423f5ebe70d04a697"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "febe4f0877f477aa1648b4343ed1dcbbeb839753bd27fd36dd27a891951678de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21e41ff2e07c5ef20fdd2cda28dca4777d595084cd455b6dfa79d782498e9514"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2451687c821568ddb1c706eefa036ebb0551932a5d73ccbc10f88611d5250ce"
    sha256 cellar: :any_skip_relocation, ventura:        "728f9068e54e92a9fbba90fe0f4e82762ad550c6f0538c8a9cddaa8791533207"
    sha256 cellar: :any_skip_relocation, monterey:       "93c2b4529c5fe54fac39f4edae90efd19d92a238e7f0ebd5cced1ca56b298425"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ab337ebd0cf408b03c3a765581986c92baf8fe0f230d8e90f3ee158c81997dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "788d987c23de2c4d5ba55833462bc7cf60a5f6844e5682e827a242fa5837e3ef"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    output = shell_output("#{bin}/killport --signal sigkill #{port}")
    assert_match "No service found using port #{port}", output
  end
end
