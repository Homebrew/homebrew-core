class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v1.4.0.tar.gz"
  sha256 "51be97c79e071b8449ea189b507527a59ace364d8bf63f334305d6152bcfd9ee"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c5c3e3afef624cc54a7e7f7684b273e412766868617827cba77c3ab5d97071d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f850bbc13babd36f7be8aedc387d83df3ef985609009271c220f41519538eb92"
    sha256 cellar: :any_skip_relocation, monterey:       "556b90dd913b3066bbec88f462ea7ce6130fef7798d715aa9fc4638842c036cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5f6a0f2badbda77d17f05263d4d10efdaf3531f0fa17f53f099c119e5347905"
    sha256 cellar: :any_skip_relocation, catalina:       "bb89114c9a6012d368ebbeaacd969b2650ecb98b6344802344d7d1aa9ce1ad0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb57780f21cb0fecb72e3ceda1fd9e0a5b30f1e5e668e50eed662897285f73c6"
  end

  depends_on "go" => :build

  def install
    ENV["WEBCONSOLE"] = "default"
    system "make", "all"

    %w[immudb immuclient immuadmin].each do |binary|
      bin.install binary
      generate_completions_from_executable(bin/binary, "completion")
    end
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
