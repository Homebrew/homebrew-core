class Ktmpl < Formula
  desc "Parameterized templates for Kubernetes manifests"
  homepage "https://github.com/jimmycuadra/ktmpl"
  url "https://github.com/jimmycuadra/ktmpl/archive/0.9.1.tar.gz"
  sha256 "3377f10477775dd40e78f9b3d65c3db29ecd0553e9ce8a5bdcb8d09414c782e9"
  license "MIT"
  head "https://github.com/jimmycuadra/ktmpl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "0a0b3e7477b6ceb8c1b32ebb47572df7ab5b050ec1d625259cf1c92c03c02e23"
    sha256 cellar: :any_skip_relocation, catalina:     "706ba7f987af4076525132bd8867c9905d96a842a46c5f6b3991439b5893f05c"
    sha256 cellar: :any_skip_relocation, mojave:       "3a884032f3b3d81433b6cc275637459a7dddd58db8d5f5bd5d044e07df5782c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "885513c3297b234f5c7c1011eb840e7ba47e5a0c6fd60b454fc3f837e00a3fb4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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
          metadata:
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
