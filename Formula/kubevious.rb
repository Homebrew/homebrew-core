require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/cli"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.43.tgz"
  sha256 "8184a7c63944149d81576720521d19220ae1f46ccee51518b294627c83225a6e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "352f7216b53c756bcf78386282a417f6d174cbb7b8898bfb117cf9726215f1b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b070427959dd8eca84266a0c1ae1bb56b147f69d2ff9eb3c97c8850601084951"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f75bd429e3b3eb46c839ceeff1fe95c44b97a73b2476867415aa9b54c2da84e"
    sha256 cellar: :any_skip_relocation, ventura:        "1b9823ed3aa1cca5f3c84cccd4335c5e2123b90e41eeadeabf0c019cf44af250"
    sha256 cellar: :any_skip_relocation, monterey:       "014d1a6cdd11e4adba5e7d94ef76d4d7e17126f39ff7a96fd4ea2da7b64744f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4ed13764c2801695940b545b0d20cd4558aceada1fe83915140aa02b6330fd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "503abf44c3cfc8fcf8343710078386ff2ab4ae219564a604f57514e4bdbb53ec"
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
