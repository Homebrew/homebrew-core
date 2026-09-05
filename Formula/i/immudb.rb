class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://immudb.io/"
  url "https://github.com/codenotary/immudb/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "5860663e92b663d0e72c2b4cd4a995090029e7d6e3b6a678115896f757300c21"
  license "Apache-2.0"
  head "https://github.com/codenotary/immudb.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05a0677a94130862db77cba29cc366dbf6839802de57314a8b27d15a6daa1a84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17fdfefe8d6ef09fb53acfbbadce791fd0ab40d585c8ab90542d7ee0cbd3f757"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea001725decd6a3e5a9c8634db35ae3bb2b7b6bc0e724b91c6eabef1f0472c98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e18996fc161ad906666306907c227009fb7420d190b1a02bbc92c4d34836b2d"
    sha256 cellar: :any,                 x86_64_linux:  "79e2201dd7f57e476e7a3fd69104a795d6cd285d8c8b96c416badaac6d2cd697"
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
