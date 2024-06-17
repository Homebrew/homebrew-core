class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "0d5235b41094cb99b1c3bb0c402b4dd76aa1457c68328818b34b3d62b73290b6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5794587fe326093617866233fcbd112c7aee0918fe1261175d456e821687b4e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4c5f882d571798515327fb55ac5a76aa313070dffb660568f3f1afce9bdd199"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18ad75efea0740b4afabfb869f50e9b44cf9e3e16a599d54b17410908d662b4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f11321f966d704926129e3e61ee87b908abc7cb5b76ffaf097ff24f0bb27e3d"
    sha256 cellar: :any_skip_relocation, ventura:        "a34c7423de52a6213eac12dddc3521a8d9f6ec275cba8bf4cf03ff67137217e0"
    sha256 cellar: :any_skip_relocation, monterey:       "931814bb8899d1abf124e58f10e63f8533f97b59c85a7767a40da45055c1eeaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4da01bb13ac00c562f4070ef3e2eccbef9d25403312b7340ea6fca95872f7914"
  end

  depends_on "go" => :build

  def install
    ENV["WEBCONSOLE"] = "default"
    system "make", "all"

    %w[immudb immuclient immuadmin].each do |binary|
      bin.install binary
      generate_completions_from_executable(bin/binary, "completion", base_name: binary)
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
