require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/kubevious"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.34.tgz"
  sha256 "268136f9c32025fcb2887be68718bf9b60dbd1f7b5bd58359095b40b8668b428"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0caf7fbfcad83ca5763e08344b7cc731dc613d4392a4d849ed6c83813d1c25b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46b200538fdfd9d9e4fdab52e3efa3179660804f2651ba2affd3a50d643a4051"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72f2a33079786c4cd518a5e680dc38a4a4d8c28e038e54b2cbbbd991cf765c70"
    sha256 cellar: :any_skip_relocation, ventura:        "6e44cd7ebdd55b0d12f4c26917145a5108b176b15823818ef329e2a343a31f8d"
    sha256 cellar: :any_skip_relocation, monterey:       "d229baea07114d986eb34e568d316462697fe1ec460dde2559bc0ee6f652a3f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c59bee199592e2783f81d05a6f4453585159f780fe1369204d3cb193cb29fb11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b86b93a84ebb70c1b3fad1619e9732f9812cd9a77b19e646bbd9be68fe1049a6"
  end

  # upstream issue to track node@18 support
  # https://github.com/kubevious/cli/issues/8
  depends_on "node@14"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"kubevious").write_env_script libexec/"bin/kubevious", PATH: "#{Formula["node@14"].opt_bin}:$PATH"
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/kubevious --version")

    (testpath/"deployment.yml").write <<~EOF
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: nginx
      spec:
        selector:
          matchLabels:
            app: nginx
        replicas: 1
        template:
          metadata:
            labels:
              app: nginx
          spec:
            containers:
            - name: nginx
              image: nginx:1.14.2
              ports:
              - containerPort: 80
    EOF

    assert_match "Lint Succeeded",
      shell_output("#{bin}/kubevious lint #{testpath}/deployment.yml")

    (testpath/"bad-deployment.yml").write <<~EOF
      apiVersion: apps/v1
      kind: BadDeployment
      metadata:
        name: nginx
      spec:
        selector:
          matchLabels:
            app: nginx
        replicas: 1
        template:
          metadata:
            labels:
              app: nginx
          spec:
            containers:
            - name: nginx
              image: nginx:1.14.2
              ports:
              - containerPort: 80
    EOF

    assert_match "Lint Failed",
      shell_output("#{bin}/kubevious lint #{testpath}/bad-deployment.yml", 100)

    assert_match "Guard Succeeded",
      shell_output("#{bin}/kubevious guard #{testpath}/deployment.yml")

    assert_match "Guard Failed",
      shell_output("#{bin}/kubevious guard #{testpath}/bad-deployment.yml", 100)

    (testpath/"service.yml").write <<~EOF
      apiVersion: v1
      kind: Service
      metadata:
        labels:
          app: nginx
        name: nginx
      spec:
        type: ClusterIP
        ports:
        - name: http
          port: 80
          targetPort: 8080
        selector:
          app: nginx
    EOF

    assert_match "Guard Failed",
      shell_output("#{bin}/kubevious guard #{testpath}/service.yml", 100)

    assert_match "Guard Succeeded",
      shell_output("#{bin}/kubevious guard #{testpath}/service.yml #{testpath}/deployment.yml")
  end
end
