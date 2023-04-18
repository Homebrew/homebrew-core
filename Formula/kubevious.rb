require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/cli"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.53.tgz"
  sha256 "5601a17c83787ad9d75d11a31ce9806fd3747ae4e2cc6970c2fba1d8960cf4c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "796afecd0e43a82238b61c2a88cfa778e7515b37a5b2e6b14b4a2f0d05a81ca9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2ee6a447fbc2564bcc77816b52706e938eaef2e88219db6547fd0a8485df807"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8f11c2181ec2b9ff1790ab789d47ec1668d2072874e4a7a46e18d05cd97f33a"
    sha256 cellar: :any_skip_relocation, ventura:        "5ba11487158cc27780d8ed4bec423ea3b410e1c5116a103510e2df0fd40401ec"
    sha256 cellar: :any_skip_relocation, monterey:       "4a91a76a294143ca21b8a8d3aef952a8c25e3c9f0d350e3810854b237cf05fde"
    sha256 cellar: :any_skip_relocation, big_sur:        "134e0f47a45bb24dc21665ccaf76b89ef12b64b6b6f82a6bedbcfadeb6139666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da31fe013744f20dcbc4680380525055eab1590f38059412c27039d27503adb7"
  end

  # Match deprecation date of `node@14`.
  # TODO: Remove if migrated to `node@18` or `node`. Update date if migrated to `node@16`.
  # Issue ref: https://github.com/kubevious/cli/issues/8
  deprecate! date: "2023-04-30", because: "uses deprecated `node@14`"

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
