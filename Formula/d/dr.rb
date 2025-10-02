class Dr < Formula
  desc "DataRobot command-line interface"
  homepage "https://github.com/datarobot-oss/cli"
  url "https://github.com/datarobot-oss/cli/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "6df4a739dae533ddc30d099d9a34954dcb081aced6e831b01ac2976a96444d80"
  license "Apache-2.0"
  head "https://github.com/datarobot-oss/cli.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"dr"
  end

  test do
    system bin/"dr", "version"
  end
end
