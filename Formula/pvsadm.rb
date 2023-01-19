class Pvsadm < Formula
  desc "Tool for managing the IBM Power Systems Virtual Servers"
  homepage "https://github.com/ppc64le-cloud/pvsadm"
  url "https://github.com/ppc64le-cloud/pvsadm/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "e94a3bd3dce57e8ec932f653b7a61909b4bf63a1af26eb6a9e8d690ff1be1adc"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-o", bin/"pvsadm"
  end

  test do
    output = shell_output("#{bin}/pvsadm get events 2>&1", 1)
    assert_match "Error: --instance-name or --instance-name required", output
  end
end
