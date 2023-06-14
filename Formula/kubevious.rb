require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/cli"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.58.tgz"
  sha256 "a2d403375f2937edc3e326e9d71f0772dcdba71d2986c9242ff191792e6b68f3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccd4d9b6208de4cdda642feadcccb70f6938b8cdf962bd815fa0f32135d4739e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccd4d9b6208de4cdda642feadcccb70f6938b8cdf962bd815fa0f32135d4739e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccd4d9b6208de4cdda642feadcccb70f6938b8cdf962bd815fa0f32135d4739e"
    sha256 cellar: :any_skip_relocation, ventura:        "b41858e2fbb9f453a50efeb51b20051920dcca7dd6c9c1c2a275b0486a201066"
    sha256 cellar: :any_skip_relocation, monterey:       "b41858e2fbb9f453a50efeb51b20051920dcca7dd6c9c1c2a275b0486a201066"
    sha256 cellar: :any_skip_relocation, big_sur:        "b41858e2fbb9f453a50efeb51b20051920dcca7dd6c9c1c2a275b0486a201066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccd4d9b6208de4cdda642feadcccb70f6938b8cdf962bd815fa0f32135d4739e"
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
