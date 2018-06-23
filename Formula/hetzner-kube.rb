class HetznerKube < Formula
  desc "CLI tool for provisioning kubernetes clusters on Hetzner Cloud"
  homepage "https://github.com/xetys/hetzner-kube"
  url "https://github.com/xetys/hetzner-kube/archive/0.3.tar.gz"
  sha256 "300ad82fdeeb5f68d034571e1269025a2da73cd55be34a1cdb7f09257b1807af"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/xetys/hetzner-kube"
    bin_path.install Dir["*"]

    cd bin_path do
      system "go", "build", "-o", bin/"hetzner-kube", "."
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hetzner-kube version")
  end
end
