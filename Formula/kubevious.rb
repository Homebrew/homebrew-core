require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/kubevious"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.29.tgz"
  sha256 "bf7062df18af4fc17a768f0e6857aae046f0a8d365fda9b9069651f49d8538c0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9392160ab4919e99cb46375950a97abef782c0bd1e3ee245480e75ed67217448"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "767af84d1e9631e2ecdf68dee63c1aba294e56ac0ff1e151c149a614d068442d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79017affe7feaecb6acbd337db6c16e7e710d07b883690db7d10b9d8a5709bc1"
    sha256 cellar: :any_skip_relocation, ventura:        "dc1c4f348133bde69ebaf684f8ce8651516bc38f520461b03bad7dac4ff80fbe"
    sha256 cellar: :any_skip_relocation, monterey:       "0bba84e000061818396ee504068674574677ef3865616ec0162142adabcd6665"
    sha256 cellar: :any_skip_relocation, big_sur:        "f403d15af346f9db7c45bbb20a23d1ac9028c5a44ab9a27bd7741eb8afbe73d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7b52bf6a8cbc2b682d571bbb073050728f38efb383b9fd1749da54f2c1034ac"
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
