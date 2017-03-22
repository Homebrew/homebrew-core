class Ktmpl < Formula
  desc "Parameterized templates for Kubernetes manifests."
  homepage "https://github.com/InQuicker/ktmpl"
  url "https://github.com/InQuicker/ktmpl/archive/0.6.0.tar.gz"
  sha256 "16338b7129c2268350d6dd780f0e41a3c5a81a7399273d85ff0939065820eba0"
  head "https://github.com/InQuicker/ktmpl.git"

  bottle do
    sha256 "6bd6fbfaa9674d19070d46a3acff6b364173fd731ce0eeeefb0a8557b648dc76" => :sierra
    sha256 "f8b81fedf479b28d6f8846a200ba67c35054f1641a4c8829e673482a9fb1a7ef" => :el_capitan
    sha256 "4df7bf2ac55cc20278a547abcb25cd3d685e2fed69d2d29a983cc2bc565f0dca" => :yosemite
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/ktmpl"
  end

  test do
    (testpath/"test.yml").write <<-EOS.undent
      ---
      kind: "Template"
      apiVersion: "v1"
      metadata:
        name: "test"
      objects:
        - kind: "Service"
          apiVersion: "v1"
          metdata:
            name: "test"
          spec:
            ports:
              - name: "test"
                protocol: "TCP"
                targetPort: "$((PORT))"
            selector:
              app: "test"
      parameters:
        - name: "PORT"
          description: "The port the service should run on"
          required: true
          parameterType: "int"
    EOS
    system bin/"ktmpl", "test.yml", "-p", "PORT", "8080"
  end
end
