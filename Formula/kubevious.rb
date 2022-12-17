require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/cli"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.39.tgz"
  sha256 "0017cabd7da979f02427d997ee5f45eab072f93d8751cf978c9f129a89f30037"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ec3815952acecf3ea5d2cad4043f8cdb0f8b0045e1ce50c532e1a9e53eb7fb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7595ccd10031801e6eb1bfd3b7b0aa0bc20f4589fd7ae0500e6c2d418f7d047d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "423adc241e7d00b8eb043fa2cf6ad238ae98af1db68d7e0d24176ffa20cf634a"
    sha256 cellar: :any_skip_relocation, ventura:        "32f4946d5574458daba8d9c556de7ff1e2374715126e9c6b90e5c8f5c4a1bf8c"
    sha256 cellar: :any_skip_relocation, monterey:       "3e6d642225cb4e4ff5f3ecad9055a10303a580472d4061744031312c27944cf9"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b39697f1a5e98ac3093031e4f795b5573a31f2090b0393dd26c5daf343fd033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4af3b158549a6bfc0f612f3d24f974e2149708a54271548cc686b9905c74cf58"
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
