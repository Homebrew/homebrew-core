class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://immudb.io/"
  url "https://github.com/codenotary/immudb/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "6023c79aa3216a965fbfd87b49b94e6bb8545f1eba2f88d22d42d5d4d5db2602"
  license "Apache-2.0"
  head "https://github.com/codenotary/immudb.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f20b4db2f48b4bd1233a449642ec793dc27027a8c0cf7e03f67f3dd1dd48a8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c49fe71fbc828430dfe1728b19f68f2647c5bfc2298392e88c88edd5e177124b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f403e41f8764d4d8ae551b9ed5659f7c9df1a071bc5ebb0cb3b5c9136172b4e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "61bb499872ea9f4eb9fcffb3e3c50203b5ee0cea50596a0d952cda50d530905d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1fb990d11cdd9950cdcbb788b8c1719c4ad0b1b12e438c54bd8e1817864b50c"
    sha256 cellar: :any,                 x86_64_linux:  "ab77a638b28c537f56e72ab94771e4fdd924fbbf190d9eafd11927b0487a9e54"
  end

  depends_on "go" => :build

  def install
    ENV["WEBCONSOLE"] = "default"
    system "make", "all"

    %w[immudb immuclient immuadmin].each do |binary|
      bin.install binary
      generate_completions_from_executable(bin/binary, shell_parameter_format: :cobra)
    end
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

    spawn bin/"immudb", "--port=#{port}"
    sleep 3

    assert_match "immuclient", shell_output("#{bin}/immuclient version")
    assert_match "immuadmin", shell_output("#{bin}/immuadmin version")
  end
end
