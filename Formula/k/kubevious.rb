require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/cli"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.59.tgz"
  sha256 "914f56db7addbd52154530483b125f8eef17f1cda231be43ea1d53d997d41d6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e15d42c234894f5eb57e8f21355c490b1811a23f30ed0497131f48aff2eae98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e15d42c234894f5eb57e8f21355c490b1811a23f30ed0497131f48aff2eae98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e15d42c234894f5eb57e8f21355c490b1811a23f30ed0497131f48aff2eae98"
    sha256 cellar: :any_skip_relocation, sonoma:         "26741c298a464c0c1f662fe6a2bd513f55efcd85e1c9dc6246ba7dd975e7f6cd"
    sha256 cellar: :any_skip_relocation, ventura:        "26741c298a464c0c1f662fe6a2bd513f55efcd85e1c9dc6246ba7dd975e7f6cd"
    sha256 cellar: :any_skip_relocation, monterey:       "26741c298a464c0c1f662fe6a2bd513f55efcd85e1c9dc6246ba7dd975e7f6cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e15d42c234894f5eb57e8f21355c490b1811a23f30ed0497131f48aff2eae98"
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
