require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/cli"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.58.tgz"
  sha256 "a2d403375f2937edc3e326e9d71f0772dcdba71d2986c9242ff191792e6b68f3"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5b735b8ac7cc099a47f32e103624b2f7b4cf38b549117827f3aa83dc867cd77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5b735b8ac7cc099a47f32e103624b2f7b4cf38b549117827f3aa83dc867cd77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5b735b8ac7cc099a47f32e103624b2f7b4cf38b549117827f3aa83dc867cd77"
    sha256 cellar: :any_skip_relocation, ventura:        "c06ee99ad24dbf8bb1bbfda8e031fd6f378416df5605839049e894903bb3864c"
    sha256 cellar: :any_skip_relocation, monterey:       "c06ee99ad24dbf8bb1bbfda8e031fd6f378416df5605839049e894903bb3864c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c06ee99ad24dbf8bb1bbfda8e031fd6f378416df5605839049e894903bb3864c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5b735b8ac7cc099a47f32e103624b2f7b4cf38b549117827f3aa83dc867cd77"
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
