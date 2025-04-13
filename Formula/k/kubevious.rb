class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/cli"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.64.tgz"
  sha256 "f67bb559bd0aee165186307e678cf03141ade8f8b79127bd10be0f47d85d0348"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf541437312693b6b7eb8c2e24d522381e69939b41e2e708bd9ac1c459bd1620"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf541437312693b6b7eb8c2e24d522381e69939b41e2e708bd9ac1c459bd1620"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf541437312693b6b7eb8c2e24d522381e69939b41e2e708bd9ac1c459bd1620"
    sha256 cellar: :any_skip_relocation, sonoma:        "174afab940f90a87e14b1f4e257044b0598400c24cf204e046a89708b4d01495"
    sha256 cellar: :any_skip_relocation, ventura:       "174afab940f90a87e14b1f4e257044b0598400c24cf204e046a89708b4d01495"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf541437312693b6b7eb8c2e24d522381e69939b41e2e708bd9ac1c459bd1620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf541437312693b6b7eb8c2e24d522381e69939b41e2e708bd9ac1c459bd1620"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/kubevious --version")

    (testpath/"deployment.yml").write <<~YAML
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
    YAML

    assert_match "Lint Succeeded",
      shell_output("#{bin}/kubevious lint #{testpath}/deployment.yml")

    (testpath/"bad-deployment.yml").write <<~YAML
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
    YAML

    assert_match "Lint Failed",
      shell_output("#{bin}/kubevious lint #{testpath}/bad-deployment.yml", 100)

    assert_match "Guard Succeeded",
      shell_output("#{bin}/kubevious guard #{testpath}/deployment.yml")

    assert_match "Guard Failed",
      shell_output("#{bin}/kubevious guard #{testpath}/bad-deployment.yml", 100)

    (testpath/"service.yml").write <<~YAML
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
    YAML

    assert_match "Guard Failed",
      shell_output("#{bin}/kubevious guard #{testpath}/service.yml", 100)

    assert_match "Guard Succeeded",
      shell_output("#{bin}/kubevious guard #{testpath}/service.yml #{testpath}/deployment.yml")
  end
end
