class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "5b0ab816e64bc1fd9d1b86366e78a551a0ed3644771f4c409ad268ab3a651282"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf3b477a86914bea123c32ea594b66f090b711888a259cc6c2ec0f0e0ed47419"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d5ce1e1bcaad65754b451d2c0c485e3624a8e8b12338f54e3be3788e542ddd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2da507966ae4c6a9f9f938b633f41c9169b06536415867aedc8d7e400c726ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "b95f29677bd302d795374b826600470f3f38e881fad23e069b1427b177d3d8e6"
    sha256 cellar: :any_skip_relocation, ventura:        "82ff44a5ac64eaf8ded21d6605fdcbf376515d113d88ed3ab6bf60512044db83"
    sha256 cellar: :any_skip_relocation, monterey:       "77a893e1d6fa1360939edc8096c47af6dcddc37b8d022b0979b5e3ec092e87c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56340b5c3c9c4710d9d3632a820e7dd072aafd83c9b631cbffa5a4df6b9d4eaf"
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
