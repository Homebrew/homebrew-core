class Ktmpl < Formula
  desc "Parameterized templates for Kubernetes manifests."
  homepage "https://github.com/InQuicker/ktmpl"
  url "https://github.com/InQuicker/ktmpl/archive/0.6.0.tar.gz"
  sha256 "16338b7129c2268350d6dd780f0e41a3c5a81a7399273d85ff0939065820eba0"
  head "https://github.com/InQuicker/ktmpl.git"

  bottle do
    sha256 "68cf4712f2b536268caebf3023c0c79449da626880e13d522a066394ef28ecf7" => :sierra
    sha256 "f6ba509072e175d269ecf5f22dcd51f6164ed701a25da2e5efc028b68cef35cc" => :el_capitan
    sha256 "17cced6dbed0e08c56f42c5871aa9882e89caf55e447091044a1ce56d3bd3795" => :yosemite
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
