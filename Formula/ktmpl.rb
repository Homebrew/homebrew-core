class Ktmpl < Formula
  desc "Parameterized templates for Kubernetes manifests"
  homepage "https://github.com/InQuicker/ktmpl"
  url "https://github.com/InQuicker/ktmpl/archive/0.7.0.tar.gz"
  sha256 "c10d26f8e834543d8f0952a76b67292cd8f10f0814128cda9bb623ffe0952615"
  head "https://github.com/InQuicker/ktmpl.git"

  bottle do
    sha256 "baa701366440c52fcd4463d4215625a16300f17360d925ca6fea7dbbeabf4dc5" => :mojave
    sha256 "b9012d8fb7919b22b93d5b44cdd7304ed2398c81a2627cb2c78302950e6016c7" => :high_sierra
    sha256 "53bd12218388a8a5d3db81c0638d85582bf04358266309bf9b62ada65901560e" => :sierra
    sha256 "9c969b22228adccf275ff10decb4f5667f0b9489d143679208b3100be683356b" => :el_capitan
    sha256 "1b56cf4694e17406aca60ebf1d6e67a8bc33f6bd3921c914aef7546fabb0f020" => :yosemite
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
