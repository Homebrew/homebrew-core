class Ktmpl < Formula
  desc "Parameterized templates for Kubernetes manifests"
  homepage "https://github.com/jimmycuadra/ktmpl"
  url "https://github.com/jimmycuadra/ktmpl/archive/0.9.0.tar.gz"
  sha256 "b2f05ae4b36f31f6801f4dcd2f5aec31d7b53b8b6dea6ddf974b22c88d8bc62b"
  head "https://github.com/jimmycuadra/ktmpl.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d8c1e6fd18fc96f615e119c64cd7df67940cb0a9b3113450e49f567b9875c9ee" => :catalina
    sha256 "7c91c4a9674effc29e0ef187fc05163500a81ac5a7c0502552b12098c72633dd" => :mojave
    sha256 "2cc0b69a68bbd12cfd02e17d079363f773006a7bd07b77588cf83d7207950b3f" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
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
