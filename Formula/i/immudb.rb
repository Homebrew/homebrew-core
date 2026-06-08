class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://immudb.io/"
  url "https://github.com/codenotary/immudb/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "ac07da5552f4d14a4d646059a633d48c7e9d668989c4522b8a9924f0c55286e0"
  license "Apache-2.0"
  head "https://github.com/codenotary/immudb.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f18ecfcb07a201bc6c11e605cbaca3362dc2b83c780ba964928c766ca83de2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ff85f8d887022854a66985e86ced6eb92821ac7f484163284af2787db31723e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7825246f18fde7624bfd81a734044d0821f948e18372347b348f67b9ed53b45"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a1c28e4f3d2e30920997f04d2618c0f67b778393bd07632b671d44d78255623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1aca578a0cb448a8b5b173a604f7c8c9ff4eb7756f8be80790799b358beef7b"
    sha256 cellar: :any,                 x86_64_linux:  "5ddee31a230eff3e62ab2c21058e3076977b40d71008bac636f8856bfde6745d"
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
