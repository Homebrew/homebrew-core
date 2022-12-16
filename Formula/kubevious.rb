require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/cli"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.37.tgz"
  sha256 "ef2c06efb4c744349fcb85028a62f0e179ccfb22399046c16f2b947743314afe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46ef7f2f844e8634cb2fa44814f859a81735243b4c11dba13a500b6e2c6f98b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a51d3db2dda857aa3ecef670969a5b2aec6029ac45775e1bda688b7479055b2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2be44acdc23e0502f27b09968ffde3f116086146268760662d17e61ab39d3d59"
    sha256 cellar: :any_skip_relocation, ventura:        "6a0d86b4bf47e1216e43a2b8a6ad331d93b61bb4fef7912f3fd15d1a25d58c57"
    sha256 cellar: :any_skip_relocation, monterey:       "f490b2bcb2644fe3eea5967543044cca1b8d189e79a09170d6ab1942b2d20602"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c28f0c4f44fdfcd85b1157f6f0c06ffd89467368e3428590ca647414434a3f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "908add9f0a065a6e5d39fe4d2346a04ed7210f41bd8701c8bd45e53c33cb5b01"
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
