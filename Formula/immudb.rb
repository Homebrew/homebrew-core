class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v1.4.1.tar.gz"
  sha256 "0530e49f7c494408615468d16abf1dc7cce3613290442613de06c75da2cf0fee"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b7307129ab0d59d3d59552982302f7f216c61400fc1dcbbf4517d41667a59ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75140b5233891e8de7b28ca9c1c619e947c6929bb296f54545e1b9348447bec2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "627415c161d24643b62527b7d0c61e8a7da4ac9cc8d8baadf8a6c152f0bd0ea7"
    sha256 cellar: :any_skip_relocation, ventura:        "59c47db568fae530b2a98df9a641615157a655baf3439f130247f0129e77ba8c"
    sha256 cellar: :any_skip_relocation, monterey:       "fa19bdc637ec2e47fcea01014edd89d42e6c50fd160d68d5031377c94200beec"
    sha256 cellar: :any_skip_relocation, big_sur:        "d93eeb424e0fe7f26ef6c6628e07f2bc5f5f111caff169a67b7beb01227788a1"
    sha256 cellar: :any_skip_relocation, catalina:       "5bcae81f2c054c1c4a334720cbe62a4de9653f0d010915e2a40e8a77ab6db04c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92dcddc1d897b8df590bda7bc310b8ba882fde86b9a4852162c47f34f44a5aa9"
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
