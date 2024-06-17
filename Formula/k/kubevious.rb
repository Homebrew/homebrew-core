require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/cli"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.61.tgz"
  sha256 "35d4f6ccc56ab5261ff5e99fd8c733f2003496cd8108e42e1b0fb158d88dee13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5b0e7d5ca95fb6fb4c7c23a34220144ad743f1906455a86bbb2ff9ebb5def89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5b0e7d5ca95fb6fb4c7c23a34220144ad743f1906455a86bbb2ff9ebb5def89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5b0e7d5ca95fb6fb4c7c23a34220144ad743f1906455a86bbb2ff9ebb5def89"
    sha256 cellar: :any_skip_relocation, sonoma:         "8bf91360d6f4b4c3ab547317d99b6bd3472378f1b1e99b714cbb52ec5ab9bb7a"
    sha256 cellar: :any_skip_relocation, ventura:        "8bf91360d6f4b4c3ab547317d99b6bd3472378f1b1e99b714cbb52ec5ab9bb7a"
    sha256 cellar: :any_skip_relocation, monterey:       "8bf91360d6f4b4c3ab547317d99b6bd3472378f1b1e99b714cbb52ec5ab9bb7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1565fc114e1b7e5f37b71e66a138708b4c54f96795c7bf6f6984d5090a4d6a20"
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
