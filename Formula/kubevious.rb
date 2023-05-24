require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/cli"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.56.tgz"
  sha256 "9ce2d7602efd7fd2a7aeeb05cd03ec0ff1abd509232a5220eb5107b38978e7ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bef6cf9e24cc8bfbbf67222c1489806485eac95b06fb1c038daff99bf6de085"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bef6cf9e24cc8bfbbf67222c1489806485eac95b06fb1c038daff99bf6de085"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bef6cf9e24cc8bfbbf67222c1489806485eac95b06fb1c038daff99bf6de085"
    sha256 cellar: :any_skip_relocation, ventura:        "ef7ff8c7dd0fc34ade34b8288350d4b66b9fee6468b21def4cecee4b66fb713b"
    sha256 cellar: :any_skip_relocation, monterey:       "ef7ff8c7dd0fc34ade34b8288350d4b66b9fee6468b21def4cecee4b66fb713b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef7ff8c7dd0fc34ade34b8288350d4b66b9fee6468b21def4cecee4b66fb713b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bef6cf9e24cc8bfbbf67222c1489806485eac95b06fb1c038daff99bf6de085"
  end

  depends_on "node@18"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"kubevious").write_env_script libexec/"bin/kubevious", PATH: "#{Formula["node@18"].opt_bin}:$PATH"
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
