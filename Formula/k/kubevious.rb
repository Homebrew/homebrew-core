require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/cli"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.60.tgz"
  sha256 "d03e17806812c60575bcd6e47b11f5dbf2a95b1f0f4b45fb33cdad22a342ac36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5ae3e51b4be2e74fcdb75912e0ff65d90ef93773f0ad6f264b3be96b7867dab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5ae3e51b4be2e74fcdb75912e0ff65d90ef93773f0ad6f264b3be96b7867dab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5ae3e51b4be2e74fcdb75912e0ff65d90ef93773f0ad6f264b3be96b7867dab"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc3f9abcb07f7189f8151b7afa8acdae1a82c916771603a51bb1e8faf2d175ca"
    sha256 cellar: :any_skip_relocation, ventura:        "bc3f9abcb07f7189f8151b7afa8acdae1a82c916771603a51bb1e8faf2d175ca"
    sha256 cellar: :any_skip_relocation, monterey:       "bc3f9abcb07f7189f8151b7afa8acdae1a82c916771603a51bb1e8faf2d175ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5ae3e51b4be2e74fcdb75912e0ff65d90ef93773f0ad6f264b3be96b7867dab"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
