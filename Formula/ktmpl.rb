class Ktmpl < Formula
  desc "Parameterized templates for Kubernetes manifests"
  homepage "https://github.com/jimmycuadra/ktmpl"
  url "https://github.com/jimmycuadra/ktmpl/archive/0.9.0.tar.gz"
  sha256 "b2f05ae4b36f31f6801f4dcd2f5aec31d7b53b8b6dea6ddf974b22c88d8bc62b"
  head "https://github.com/jimmycuadra/ktmpl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bce65a0392eac5a00c48aa703c8afaa66224588ac357363076278002a63b9c6d" => :catalina
    sha256 "4387bf621c411a8d59791a0bda3d83e6ee1279c71bee0738d2c5912319a8b77b" => :mojave
    sha256 "bd4b35069ade7f55ffe0fb1cd3f1b605cc0703b69b0a5dcea543a7e3f170a8f3" => :high_sierra
    sha256 "e3e22aa7c9144e4536e3c7417309f16c4af16aa28fd8e78642663258e21f6837" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"test.yml").write <<~EOS
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
