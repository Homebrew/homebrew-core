class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v1.2.4.tar.gz"
  sha256 "dd7f7ef1bae8d34ebaa1bb8d1099a1b0809dd6bac0d36fdc279139087dcedb79"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2eb5d591b8b3d5cba6f21b72a25b45bd9e877826e385d775f1f8d0943915e85c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56d2e49783d2e7cd1d8d294b8296103456798d8cbc88dc928f26ea61b39322aa"
    sha256 cellar: :any_skip_relocation, monterey:       "b79c1fbba63722c2f5d8b4baeff37c95d28cf8363d4acaaea3ab5abe0b09eb98"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1c13f1a07cac939a8a1423106a05e63a11150b0cb228c160353323f57cddb98"
    sha256 cellar: :any_skip_relocation, catalina:       "481624cee7d5f2d109f4c4f27befb332bee9e4772efb5ab655f001037ef3f9b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf822b40d8efd272a64b408352dcedf234003c94eed601b08df29c7214ece017"
  end

  depends_on "go" => :build

  def install
    system "make", "all"
    bin.install %w[immudb immuclient immuadmin]
  end

  def post_install
    (var/"immudb").mkpath
  end

  service do
    run opt_bin/"immudb"
    keep_alive true
    error_log_path var/"log/immudb.log"
    log_path var/"log/immudb.log"
    working_dir var/"immudb"
  end

  test do
    port = free_port

    fork do
      exec bin/"immudb", "--port=#{port}"
    end
    sleep 3

    assert_match "immuclient", shell_output("#{bin}/immuclient version")
    assert_match "immuadmin", shell_output("#{bin}/immuadmin version")
  end
end
