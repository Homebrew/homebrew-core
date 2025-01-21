class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "6667ce0b5338115caecb807eb03e81774f468220d57835939a4a721fd4db46a1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28ac596852dc2e66aea7103ce88016847a2aaa65b2dc0580ee723bd306b922f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6579433f909e522bc99b1343220c68157a60f6560d9adc5875bb7c2a758da2fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0e4a9e5757ab37b6000dba40506d51b092cf49f96658d03ec906dee203c348b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee940f265bfca03b0f33bebcbe0890bdbb2363f0c4e321ac430c34f7f2513803"
    sha256 cellar: :any_skip_relocation, ventura:       "d42ea9b2aabe4821960459e21500d31c9d6228c559e0dcbe87ba284fd88893df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ffebfff376a04a6551ffb14b03cd6f187c5af793fc32e282ceb58c4ec4f34a3"
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
