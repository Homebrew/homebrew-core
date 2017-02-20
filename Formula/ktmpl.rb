class Ktmpl < Formula
  desc "Parameterized templates for Kubernetes manifests."
  homepage "https://github.com/InQuicker/ktmpl"
  url "https://github.com/InQuicker/ktmpl/archive/0.5.0.tar.gz"
  sha256 "36924798cb88ddc98f43fea33aff894297cf4068a00157e08bf53373a79bb12c"
  head "https://github.com/InQuicker/ktmpl.git"

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
